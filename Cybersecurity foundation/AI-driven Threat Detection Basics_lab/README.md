This lab introduces the basics of AI-driven threat detection using statistical analysis, real-time monitoring, and machine learning on security logs.

## Objectives
- Generate sample security log data
- Detect anomalies using statistical methods
- Configure real-time monitoring and alerts
- Train ML models for threat classification
- Evaluate trained detection models

## Prerequisites
- Ubuntu 20.04+ or similar Linux environment
- Python 3.8+
- pip installed
- Basic Python, Linux, and statistics knowledge

## Project Structure
~/threat_detection_lab/
├── logs/
├── scripts/
├── models/
└── alerts/
Setup

Install dependencies and create the project structure:

sudo apt update
pip3 install pandas numpy scikit-learn matplotlib
mkdir -p ~/threat_detection_lab/{logs,scripts,models,alerts}
cd ~/threat_detection_lab
Workflow

Generate sample log data

Run statistical anomaly detection

Start real-time monitoring and test alerts

Train machine learning models

Evaluate saved models

Key Files

logs/system.log — generated log data

scripts/log_analyzer.py — statistical analysis

scripts/real_time_monitor.py — alert monitoring

scripts/ml_threat_detector.py — model training

scripts/model_evaluator.py — model evaluation

alerts/threat_alerts.log — generated alerts

models/*.pkl — trained models

Run Commands

Use the provided commands.sh file or run commands manually step by step.

Expected Outcome

By the end of this lab, you should have:

Parsed and analyzed log data

Detected suspicious patterns statistically

Triggered alerts from live log entries

Trained Isolation Forest and Random Forest models

Evaluated model predictions on log-based features
