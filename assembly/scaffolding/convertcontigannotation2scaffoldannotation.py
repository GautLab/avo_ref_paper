#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@author: Edwin
"""

#import gzip, argparse
import copy

asmfasta = 'gwen_scaffolds.fasta'
geneannotation = 'gwen_braker_rnaseq_scaffold_annotation.gtf'
scaffoldannotation = 'gwen_scaffolds.gff'
teannotation = 'gwen_TE_annotation.gff'
contiglens = 'pamer.contigs.c21.consensus.consensus_pilon_pilon.lengths'
stepsize = 20000
#tig00020948     AUGUSTUS        stop_codon      1126549 1126551 .       -       0       transcript_id "file_1_file_1_jg41002.t2"; gene_id "file_1_file_1_jg41002";
# from contigs
# bedtools getfasta -fi pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta -bed test.gtf -s
#>tig00020948:1126548-1126551(-)
#TAA
# from scaffolds
#3	tig00020948	-	0	3466096
#3	tig00001181	*	0	332924
#3	tig00020946	-	0	4976912
# since tig00020948 is - then we have to invert
# we need 4 examples:

# 1. pos strand first contig in scaff: same pos
#    Chr3   blah    blah    str(minpos) str(maxpos)
# bedtools getfasta -fi gwen_scaffolds.fasta -bed testscaff.gtf -s

# 2. opp strand first contig in scaff: diff pos lencontig-maxpos:lencontig-minpos then invert string flip sign of strand
#   Chr3    blah    blah    str(len(contig)-maxpos+1) str(len(contig)-minpos+1)
# Chr3    AUGUSTUS        stop_codon      2339546 2339548 .       +       0       transcript_id "file_1_file_1_jg41002.t2"; gene_id "file_1_file_1_jg41002";
# bedtools getfasta -fi gwen_scaffolds.fasta -bed testscaff.gtf -s

# 3. pos strand second or more contig in scaff
# 4. opp strand second or more contig in scaff


mycontigsdict = dict()

fin = open(contiglens)
mycontiglens = fin.readlines()
fin.close()
for i in range(0, len(mycontiglens)):
    mycontiglens[i] = mycontiglens[i].strip().split()
    contig = mycontiglens[i][0]
    length = mycontiglens[i][1]
    if contig in mycontigsdict.keys():
        print('Duplicate contig exists: ' + contig)
        #quit()
    mycontigsdict[contig] = [int(length)]

mycontiglens = list()

fin = open(scaffoldannotation)
myscaffannotations = fin.readlines()
fin.close()
xsomeplace = 1
prevxsome = ''
for i in range(0, len(myscaffannotations)):
    myscaffannotations[i] = myscaffannotations[i].strip().split()
    xsome = 'Chr' + myscaffannotations[i][0]
    contig = myscaffannotations[i][1]
    direction = myscaffannotations[i][2]
    if direction == '*':
        direction = '+'
    if xsome == prevxsome:
        xsomeplace += 1
    else:
        xsomeplace = 1
    if (not contig in mycontigsdict.keys()):
        print('Contig present in Scaffold annotation but not in original assembly')
        #quit()
    mycontigsdict[contig].append(xsome)
    mycontigsdict[contig].append(direction)
    mycontigsdict[contig].append(xsomeplace)
    prevxsome = xsome


geneannotation = 'test.gtf'

fin = open(geneannotation)
mylines = fin.readlines()
for i in range(0, len(mylines)):
    mylines[i] = mylines[i].strip().split('\t')
    mylines[i][3] = int(mylines[i][3])
    mylines[i][4] = int(mylines[i][4])

mynewannotationlines = copy.deepcopy(mylines)

for i in range(0, len(mylines)):
    scaff = mycontigsdict[mylines[i][0]][1]
    pos1 = mycontigsdict[mylines[i][0]][0] - mynewannotationlines[i][3] + 1 + stepsize*(mycontigsdict[mylines[i][0]][3] - 1)
    pos2 = mycontigsdict[mylines[i][0]][0] - mynewannotationlines[i][4] + 1 + stepsize*(mycontigsdict[mylines[i][0]][3] - 1)
    minpos = min(pos1, pos2)
    maxpos = max(pos1, pos2)
    scaffdirection = mycontigsdict[mylines[i][0]][2]
    annotationdirection = mylines[i][6]
    if scaffdirection == '-':
        if annotationdirection == '-':
            newdirection = '+'
        else:
            newdirection = '-'
    else:
        newdirection = annotationdirection
    mynewannotationlines[i][0] = scaff

