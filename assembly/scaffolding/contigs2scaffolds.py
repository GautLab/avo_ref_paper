#!/bin/env python
import glob, argparse

parser = argparse.ArgumentParser(description='Create scaffolds from scaffold annotation.')
parser.add_argument('-i', '--input', help='Input GFF file containing scaffold annotation', type=str, required=True)
parser.add_argument('-c', '--contigs', help='Location of directory containing contigs', type=str, required=True)
parser.add_argument('-o', '--output', help='Output scaffolded fasta file', type=str, required=True)
parser.add_argument('-n', '--ngaplen', help='# of N"s inbetween contigs', type=str, required=True)
args = parser.parse_args()
gfffn = args.input
output = args.output
fastadir = args.contigs
if args.ngaplen == None:
	ngaplen = 20000
else:
	ngaplen = int(args.ngaplen)

fout = open(output, 'w')

def reversecomplement(file):
	fin = open(file)
	header = fin.readline()
	sequence = fin.readline()
	fin.close()
	header = header.strip()
	sequence = sequence.strip()
	newsequence = sequence[::-1]
	tempsequence = ''
	for i in range(0, len(newsequence)):
		mychar = newsequence[i]
		if mychar == 'A':
			mychar = 'T'
		elif mychar == 'a':
			mychar = 't'
		elif mychar == 'T':
			mychar = 'A'
		elif mychar == 't':
			mychar = 'a'
		elif mychar == 'C':
			mychar = 'G'
		elif mychar == 'c':
			mychar = 'g'
		elif mychar == 'G':
			mychar = 'C'
		elif mychar == 'g':
			mychar = 'c'
		elif mychar == 'N':
			mychar = 'N'
		else:
			print('unkown char: ' + mychar + ' in file: ' + file + '\n')
		tempsequence = tempsequence + mychar
	return[header, tempsequence]


fin = open(gfffn)
mylines = fin.readlines()
for i in range(0,len(mylines)):
	mylines[i] = mylines[i].strip().split('\t')

# chr	contigs	direction

mychrsequence = ''
myprevchr = mylines[0][0]
if mylines[0][2] == '-':
	mycontigsequence = reversecomplement(fastadir + mylines[0][1] + '.fasta')[1]
else:
	fin = open(fastadir + mylines[0][1] + '.fasta')
	temp = fin.readline()
	temp = fin.readline()
	mycontigsequence = temp.strip()

mychrsequence = mycontigsequence[:]

for i in range(1, len(mylines)):
	mycurrchar = mylines[i][0]
	if mylines[i][2] == '-':
		mycontigsequence = reversecomplement(fastadir + mylines[i][1] + '.fasta')[1]
	else:
		fin = open(fastadir + mylines[i][1] + '.fasta')
		temp = fin.readline()
		temp = fin.readline()
		mycontigsequence = temp.strip()
	if mycurrchar == myprevchr:
		# aggregate
		mychrsequence = mychrsequence + 'N'*ngaplen + mycontigsequence
	else:
		fout.write('>Chr' + myprevchr + '\n')
		fout.write(mychrsequence + '\n')
		myprevchr = mycurrchar
		mychrsequence = mycontigsequence[:]
	if i == len(mylines) - 1:
		print('hit the end!')
		fout.write('>Chr' + mycurrchar + '\n')
		fout.write(mychrsequence + '\n')

fout.close()
