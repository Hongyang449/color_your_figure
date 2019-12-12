#!/usr/bin/env python
import os
import sys
import numpy as np
import re
import scipy.io
import pyBigWig


def score_record(truth, predictions, input_digits=None):
    if input_digits is None: # bin resolution
        input_digits = 3
    scale=10**input_digits
    pos_values = np.zeros(scale + 1, dtype=np.int64)
    neg_values = np.zeros(scale + 1, dtype=np.int64)
    b = scale+1
    r = (-0.5 / scale, 1.0 + 0.5 / scale) # default 1001 bins
    all_values = np.histogram(predictions, bins=b, range=r)[0] # num of pred in each bin
    if np.sum(all_values) != len(predictions):
        raise ValueError("invalid values in 'predictions'")
    pred_pos = predictions[truth > 0]
    pos_values = np.histogram(pred_pos, bins=b, range=r)[0]
    pred_neg = predictions[truth == 0]
    neg_values = np.histogram(pred_neg, bins=b, range=r)[0]
    return (pos_values, neg_values)

def calculate_auc(pos_values,neg_values): # auc & auprc; adapted from score2018.py
    tp = np.sum(pos_values) # start from cutoff=0
    fp = np.sum(neg_values)
    tn = fn = 0
    tpr = 1
    tnr = 0
    if tp == 0 or fp == 0:
        # If either class is empty, scores are undefined.
        return (float('nan'), float('nan'))
    ppv = float(tp) / (tp + fp)
    auroc = 0
    auprc = 0
    ppv_all = [] # precision
    tpr_all = [] # recall
    fpr_all = [] # fpr = 1-tnr
    ppv_all.append(ppv)
    tpr_all.append(tpr)
    fpr_all.append(1-tnr)
    for (n_pos, n_neg) in zip(pos_values, neg_values):
        tp -= n_pos
        fn += n_pos
        fp -= n_neg
        tn += n_neg
        tpr_prev = tpr
        tnr_prev = tnr
        ppv_prev = ppv
        tpr = float(tp) / (tp + fn)
        tnr = float(tn) / (tn + fp)
        if tp + fp > 0: # when cutoff = 1, tp + fp = 0 
            ppv = float(tp) / (tp + fp)
        else:
            ppv = ppv_prev
        auroc += (tpr_prev - tpr) * (tnr + tnr_prev) * 0.5 # trapezoid
        auprc += (tpr_prev - tpr) * ppv_prev # rectangle
        ppv_all.append(ppv)
        tpr_all.append(tpr)
        fpr_all.append(1-tnr)
    ppv_all=np.array(ppv_all)
    tpr_all=np.array(tpr_all)
    fpr_all=np.array(fpr_all)
    return (auroc, auprc, ppv_all, tpr_all, fpr_all)


list_chr=['chr1','chr8','chr21']

path0='./epoch20/'
path_computer='../../data/'
path1=path_computer + 'test_chipseq_conservative_refine_bigwig/' # label
#path3=path_computer + 'motif_scan/motif_start_multip/' # fimo scan

the_tf='NANOG'
test_cell=['induced_pluripotent_stem_cell']
num_par = 2

reso_auc=3

for the_cell in test_cell:
    print(the_cell)
    positives_all = np.zeros(10**reso_auc+1)
    negatives_all = np.zeros(10**reso_auc+1)
    bw1=pyBigWig.open(path1 + the_tf + '_' + the_cell + '.bigwig')
    for the_chr in list_chr:
        the_name='pred_' + the_tf + '_' + the_cell + '_' + the_chr
        for k in np.arange(1,num_par + 1):
            if k==1:
                pred=np.load(path0 + the_name + '_par' + str(k) + '.npy')
            else:
                pred+=np.load(path0 + the_name + '_par' + str(k) + '.npy')
        pred = pred / num_par
        os.system('mkdir -p best_pred')
        np.save('./best_pred/' + the_name, pred)

        length = pred.shape[0] 
        dust = np.array(bw1.values(the_chr, 0, length))
        positives, negatives = score_record(dust, pred, input_digits=reso_auc)
        positives_all += positives
        negatives_all += negatives
        auc, auprc, precision, recall, fpr = calculate_auc(positives, negatives)
        np.save('roc_prc_' + the_cell + '_' + the_chr, np.vstack((precision, recall, fpr)))

    auc, auprc, precision, recall, fpr = calculate_auc(positives_all, negatives_all)
    np.save('roc_prc_' + the_cell + '_overall' , np.vstack((precision, recall, fpr)))





