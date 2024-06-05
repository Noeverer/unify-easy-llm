
BASE_CODE_PATH="/home/guodong.li"
PROJECT_PATH="$BASE_CODE_PATH/workspace/llm-train"

TRAIN_ARGS_PATH="$PROJECT_PATH/sft-config.json"

LOCAL_PROGRESS_PATH="$BASE_CODE_PATH/workspace/temp/output/progress.json"

cat <<EOF > $LOCAL_PROGRESS_PATH
{
    "metrics": {},
    "errMsg": "",
    "progress": 0
}
EOF


# /workspace/model/Baichuan2-7B-Chat
# /workspace/model/Qwen1.5-7B-Chat
cat <<EOF > $TRAIN_ARGS_PATH
{
    "output_dir": "$BASE_CODE_PATH/workspace/temp/output",
    "logging_dir": "$BASE_CODE_PATH/workspace/temp/logs",
    "model_name_or_path": "$BASE_CODE_PATH/workspace/temp/models",
    "train_file": "$BASE_CODE_PATH/workspace/temp/datas",
    "model_metrics_path": "$BASE_CODE_PATH/workspace/temp/output/progress.json",
    "model_temp_output_path": "$BASE_CODE_PATH/workspace/temp/outputs",

    "deepspeed": "$PROJECT_PATH/train_args/ds_z2_offload.json",

    "num_train_epochs": 1,
    "per_device_train_batch_size": 1,
    "gradient_accumulation_steps": 4,
    "learning_rate": 1e-5,
    "max_seq_length": 1024,
    "logging_steps": 1,
    "save_steps": 500,
    "save_total_limit": 1,
    "lr_scheduler_type": "cosine",
    "warmup_ratio": 0.1,
    "gradient_checkpointing": true,
    "disable_tqdm": false,
    "optim": "adamw_hf",
    "seed": 42,
    "fp16": true,
    "report_to": "tensorboard",
    "dataloader_num_workers": 0,
    "save_strategy": "steps",
    "weight_decay": 0,
    "max_grad_norm": 1.0,
    "remove_unused_columns": false,
    "prompt_template_name": "default"
}
EOF

echo "训练参数: "
cat $TRAIN_ARGS_PATH

gpu_num=2
echo "执行训练任务脚本："
echo "cd $PROJECT_PATH && CUDA_VISIBLE_DEVICES=0,5 deepspeed --num_gpus=$gpu_num train.py --train_args_file $TRAIN_ARGS_PATH"
cd $PROJECT_PATH && CUDA_VISIBLE_DEVICES=0,5 deepspeed --num_gpus=$gpu_num train.py --train_args_file $TRAIN_ARGS_PATH

