#!/bin/bash
# Fastfetch with random logo
IMG_DIR="$HOME/.config/dreamcoder"
IMGS=(Dreamcoder01.jpg Dreamcoder02.jpg Dreamcoder03.jpg Dreamcoder04.jpg Dreamcoder05.jpg Dreamcoder06.jpg Dreamcoder07.jpg Dreamcoder08.jpg Dreamcoder09.jpg)
RANDOM_IMG="${IMGS[$((RANDOM % 9))]}"
fastfetch -l "$IMG_DIR/$RANDOM_IMG"
