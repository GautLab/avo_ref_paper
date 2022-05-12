#!/bin/env python
import glob

mapfile = 'gwen_fuerte_consensus_map.tsv'
#mapfile = 'gwen_map.tsv'
alignmentfile = 'SHRSPa_sequence_pamer.contigs.c21.consensus.consensus_pilon_pilon_1e10_blastn.outfmt6'
outfile = mapfile.replace('.tsv', '_anchored.tsv')

fin = open(mapfile)
mymaplines = fin.readlines()

fin = open(alignmentfile)
myalignmentlines = fin.readlines()
fin.close()

mymaplines = mymaplines[1:]
for i in range(0, len(mymaplines)):
    mymaplines[i] = mymaplines[i].strip().split()

mymaplines = sorted(mymaplines, key=lambda x: (int(x[2]), float(x[1])))

myset = set()
for i in range(0, len(mymaplines)):
    myset.add(mymaplines[i][0])

if len(myset) != len(mymaplines):
    print('Duplicate markers exist. Please check and fix. Find duplicates by running: awk "{print $1}" ' + mapfile + ' | sort | uniq -d')

for i in range(0, len(myalignmentlines)):
    myalignmentlines[i] = myalignmentlines[i].strip().split()

mymapdict = dict()

for i in range(0, len(mymaplines)):
    mymapdict[mymaplines[i][0]] = [[]]

for i in range(0, len(myalignmentlines)):
    mykey = myalignmentlines[i][0]
    if(mykey in mymapdict.keys()):
        mymapdict[mykey][0].append(myalignmentlines[i][1:])

fout = open(outfile, 'w')
fout.write('Marker\tcM\tLinkage_group\tAlignments\n')
for i in range(0, len(mymaplines)):
    mykey = mymaplines[i][0]
    if mykey in mymapdict.keys():
        fout.write(mymaplines[i][0] + '\t' + mymaplines[i][1] + '\t' + mymaplines[i][2] + '\n')
        for j in range(0, len(mymapdict[mykey][0])):
            fout.write('\t\t')
            for k in range(0, len(mymapdict[mykey][0][j])):
                fout.write('\t' + mymapdict[mykey][0][j][k])
            fout.write('\n')
    else:
        fout.write(mymaplines[i][0] + '\t' + mymaplines[i][1] + '\t' + mymaplines[i][2] + '\n')

fout.close()

