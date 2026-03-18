```bash
#!/bin/bash

set -e

echo "Updating package list..."
sudo apt update

echo "Installing Python dependencies..."
pip3 install pandas numpy scikit-learn matplotlib

echo "Creating project structure..."
mkdir -p ~/threat_detection_lab/{logs,scripts,models,alerts}

echo "Moving into lab directory..."
cd ~/threat_detection_lab

echo "Make sure the following files are created before running all steps:"
echo "  - generate_logs.py"
echo "  - scripts/log_analyzer.py"
echo "  - scripts/real_time_monitor.py"
echo "  - scripts/ml_threat_detector.py"
echo "  - scripts/model_evaluator.py"
echo "  - scripts/alert_config.json"

echo "Making scripts executable where needed..."
chmod +x generate_logs.py 2>/dev/null || true
chmod +x scripts/log_analyzer.py 2>/dev/null || true
chmod +x scripts/real_time_monitor.py 2>/dev/null || true
chmod +x scripts/ml_threat_detector.py 2>/dev/null || true
chmod +x scripts/model_evaluator.py 2>/dev/null || true

echo "Generating sample logs..."
python3 generate_logs.py

echo "Running statistical anomaly detection..."
cd ~/threat_detection_lab/scripts
python3 log_analyzer.py

echo "Training machine learning models..."
python3 ml_threat_detector.py

echo "Evaluating trained models..."
python3 model_evaluator.py

echo "Starting real-time monitor..."
echo "Open another terminal and append test threats to ~/threat_detection_lab/logs/system.log"
python3 real_time_monitor.py
