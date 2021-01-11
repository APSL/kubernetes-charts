local := http:\/\/127.0.0.1:8879
remote := https:\/\/raw.githubusercontent.com\/APSL\/kubernetes-charts\/master\/packages

all: help

.PHONY: help # Help
help:
	@grep '^.PHONY:.*' Makefile | sed 's/\.PHONY:[ \t]\+\(.*\)[ \t]\+#[ \t]*\(.*\)/\1	\2/' | expand -t20

.PHONY: helm-up # Serve helm packages.
helm-up:
	chartmuseum --debug --port=8879 --storage="local"  --storage-local-rootdir="./packages"

.PHONY: helm-packages # Build all Charts and its dependencies generating the packages.
helm-packages:
	for x in */requirements.*; do sed -i -e "s/${remote}/${local}/g" $$x; done
	for x in */Chart.yaml; do echo "packaging $$(dirname $$x)..." && helm package -u -d packages $$(dirname $$x); done
	for x in */requirements.*; do sed -i -e "s/${local}/${remote}/g" $$x; done

.PHONY: helm-index # Generate the YAML index to serve the available packages.
helm-index:
	helm repo index packages
