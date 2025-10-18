.PHONY: help install format train eval update-branch hf-login push-hub deploy all

help:
	@echo Comandos disponibles:
	@echo   make install       - Instalar dependencias
	@echo   make format        - Formatear codigo con Black
	@echo   make train         - Entrenar modelo
	@echo   make eval          - Evaluar modelo y crear reporte
	@echo   make update-branch - Actualizar rama con nuevos resultados
	@echo   make hf-login      - Login en HuggingFace
	@echo   make push-hub      - Subir archivos a HuggingFace Hub
	@echo   make deploy        - Deploy completo (login + push)
	@echo   make all           - Ejecutar todo

install:
	python -m pip install -r requirements.txt

format:
	python -m black *.py

train:
	python train.py

eval:
	@echo ## Model Metrics > report.md
	@type .\Results\metrics.txt >> report.md
	@echo. >> report.md
	@echo ## Confusion Matrix Plot >> report.md
	@echo ![Confusion Matrix](./Results/models_results.png) >> report.md
	@echo Reporte creado en report.md

update-branch:
	git commit -am "Update with new results"
	git push origin main

hf-login:
	pip install -U "huggingface_hub[cli]"
	git pull origin main
	huggingface-cli login

push-hub:
	huggingface-cli upload Gatling-D-Ace/Drug-Classification ./App --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload Gatling-D-Ace/Drug-Classification ./Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload Gatling-D-Ace/Drug-Classification ./Results --repo-type=space --commit-message="Sync Metrics"

deploy: hf-login push-hub

all: install format train eval update-branch deploy