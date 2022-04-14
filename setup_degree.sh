# clone the repo
git clone https://github.com/jishnujayakumar/DEGREE && cd DEGREE;
export ROOT_DIR=$PWD

# cloen dygiepp
git clone https://github.com/dwadden/dygiepp
cd dygiepp;

# create env for data-preprocessing
python -m venv data-preprocess # python==3.8
source data-preprocess/bin/activate

# install required dependencies for data pre-processing
pip install -r scripts/data/ace-event/requirements.txt
pip install wheel; python -m spacy download en_core_web_sm;

# use default setting for preprocessing
python ./scripts/data/ace-event/parse_ace_event.py default-settings

echo -e "DATA available at: ./data/ace-event/raw-data"

# deactivate env as preprocesssing is complete
deactivate

cd $ROOT_DIR

# create env for data-preprocessing
python -m venv env # python==3.8
source env/bin/activate

cd -

mkdir -p data/ace-event/collated-data/default-settings/json

python scripts/data/shared/collate.py \
  data/ace-event/processed-data/default-settings/json \
  data/ace-event/collated-data/default-settings/json \
  --file_extension json

deactivate

echo -e "DATA available at: ./data/ace-event/collated-data/default-settings/json/"

cd $ROOT_DIR
mkdir processed_data

ln -s $ROOT_DIR/dygiepp/data/ace-event/collated-data/default-settings/json ace05e_dygieppformat

cd $ROOT_DIR
# create env for data-preprocessing
python -m venv degree-env # python==3.8
source degree-env/bin/activate

pip install -r requirements.txt
./scripts/process_ace05e.sh
python -c "import stanza; stanza.download('en'); stanza.download('ar'); stanza.download('zh-hans')"

# ./scripts/train_degree_e2e.sh
python degree/generate_data_degree_e2e.py -c config/config_degree_e2e_ace05e.json
python degree/train_degree_e2e.py -c config/config_degree_e2e_ace05e.json


python degree/generate_data_degree_ed.py -c config/config_degree_ed_ace05e.json
python degree/train_degree_ed.py -c config/config_degree_ed_ace05e.json

python degree/generate_data_degree_eae.py -c config/config_degree_eae_ace05e.json
python degree/train_degree_eae.py -c config/config_degree_eae_ace05e.json

# Get evaluation command