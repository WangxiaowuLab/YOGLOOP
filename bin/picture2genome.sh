#!/usr/bin/bash
#Description: convert loop from picture.
#Usage:sh picture2genome.sh dir
#Author: zhanglp
#Date: 20241218

dir=$1
CONF=$2
WINDOW=$3

ls $dir | while read name;
do
chr=`echo $name | cut -d "_" -f 1`
start=`echo $name | cut -d "_" -f 2`
#let end=$start+20000
awk -v conf=$CONF -v w=$WINDOW '$1>conf{print int($2/800*w),int($3/800*w),int($4/800*w),int($5/800*w)}' ${dir}/${name} | awk -v chr=$chr -v s=$start 'BEGIN{OFS="\t"}{print chr,$2+s,$4+s,chr,$1+s,$3+s}' >> tmp_loop.bedpe
done
pgltools formatbedpe tmp_loop.bedpe | pgltools sort - | pgltools merge -stdInA | grep -v "#" > raw_loop.bedpe

rm tmp_loop.bedpe
