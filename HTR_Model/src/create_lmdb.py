import argparse
import pickle
import os

import cv2
import lmdb
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--data_dir', type=Path, required=True)
args = parser.parse_args()

# 2GB is enough for IAM dataset
assert not (args.data_dir / 'lmdb').exists()
env = lmdb.open(str(args.data_dir / 'lmdb'), map_size=1024 * 1024 * 1024 * 2)

# go over all png files
# p = Path(file_path)
# p.as_posix()
# p = Path(args.data_dir / 'img')
# p.as_posix()
# print(p.as_posix())
# fn_imgs = list((p.as_posix()).walkfiles('*.png'))
fn_imgs = list(os.walk(args.data_dir / 'img'))
print(len(fn_imgs[0]))

# and put the imgs into lmdb as pickled grayscale imgs
with env.begin(write=True) as txn:
    for i, fn_img in enumerate(fn_imgs):
        # print(i,fn_img)
        img = cv2.imread(str(fn_img), cv2.IMREAD_GRAYSCALE)
        print(img)
        basename = fn_img.basename()
        txn.put(basename.encode("ascii"), pickle.dumps(img))

env.close()
