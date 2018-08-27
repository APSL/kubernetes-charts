helm-up:
	helm serve

helm-packages:
	for x in */Chart.yaml; do helm package -u -d packages $$(dirname $$x); done

helm-index:
	helm repo index packages