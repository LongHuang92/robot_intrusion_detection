# Robot Intrusion Detection

## Setup

_Instructions refer to Unix-based systems (e.g. Linux, MacOS)._

`cd robot_intrusion_detection/`

This code has been tested with `Python 3.7` and `3.8`.

`pip install -r requirements.txt`

## Train models from scratch

```bash
python src/main.py --output_dir experiments --comment "classification from Scratch" --name $1_fromScratch --records_file Classification_records.xls --data_dir path/to/Datasets/Classification/$1/ --data_class robot --pattern TRAIN --val_pattern TEST --epochs 400 --lr 0.001 --optimizer RAdam  --pos_encoding learnable  --task classification  --key_metric accuracy
```

## Fine-tune pretrained models

Make sure that network architecture parameters (e.g. `d_model`) used to fine-tune a model match the pretrained model.

```bash
python src/main.py --output_dir experiments --comment "finetune for classification" --name Robot_finetuned --records_file Classification_records.xls --data_dir /path/to/Datasets/Classification/Robot/ --data_class robot --pattern TRAIN --val_pattern TEST --epochs 100 --lr 0.001 --optimizer RAdam --batch_size 128 --pos_encoding learnable --d_model 64 --load_model path/to/Robot_pretrained/checkpoints/model_best.pth --task classification --change_output --key_metric accuracy
```
# robot_intrusion_detection
