import sys
import glob
import os
import json
import re
import pandas as pd


def get_column_names(schemas, ds_name, sorting_key='column_position'):
    column_details = schemas[ds_name]
    columns = sorted(column_details, key=lambda col: col[sorting_key])
    return [col['column_name'] for col in columns]


def read_csv(file, schemas):
    file_path_list = re.split('[/\\\]', file)
    ds_name = file_path_list[-2]
    columns = get_column_names(schemas, ds_name)
    df = pd.read_csv(file, names=columns)
    return df


def to_json(df, tgt_base_dir, ds_name, file_name):
    json_file_path = f'{tgt_base_dir}/{ds_name}/{file_name}'
    os.makedirs(f'{tgt_base_dir}/{ds_name}', exist_ok=True)
    df.to_json(
        json_file_path,
        orient='records',
        lines=True
    )


def file_converter(src_base_dir, tgt_base_dir, ds_name):
    schemas = json.load(open(f'{src_base_dir}/schemas.json'))
    files = glob.glob(f'{src_base_dir}/{ds_name}/part-*')
    if len(files) == 0:
        raise NameError(f'No files found for {ds_name}')

    for file in files:
        df = read_csv(file, schemas)
        file_name = re.split('[/\\\]', file)[-1]
        to_json(df, tgt_base_dir, ds_name, file_name)


def process_files(ds_names=None):
    src_base_dir = os.environ.get('SRC_BASE_DIR')
    tgt_base_dir = os.environ.get('TGT_BASE_DIR')
    schemas = json.load(open(f'{src_base_dir}/schemas.json'))
    if not ds_names:
        ds_names = schemas.keys()
    for ds_name in ds_names:
        try:
            print(f'Processing {ds_name}')
            file_converter(src_base_dir, tgt_base_dir, ds_name)
        except NameError as ne:
            print(ne)
            print(f'Error Processing {ds_name}')
            pass


if __name__ == '__main__':
    if len(sys.argv) == 2:
        ds_names = json.loads(sys.argv[1]) 
        process_files(ds_names)
    else:
        process_files()