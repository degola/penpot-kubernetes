NAMESPACE := penpot
CLUSTER := example-cluster
PENPOT_DOMAIN := penpot.example.com
PENPOT_REGISTRATION_DOMAIN_WHITELIST := "domain1.com,example2.com"

install:
	kubectl config use-context $(CLUSTER)
	kubectl config set-context --current --cluster=$(CLUSTER) --namespace=$(NAMESPACE)

	kubectl create namespace $(NAMESPACE) || true
	PENPOT_DOMAIN=$(PENPOT_DOMAIN) PENPOT_REGISTRATION_DOMAIN_WHITELIST=$(PENPOT_REGISTRATION_DOMAIN_WHITELIST) envsubst <./secrets.yaml | kubectl apply --namespace $(NAMESPACE) -f -
	PENPOT_DOMAIN=$(PENPOT_DOMAIN) PENPOT_REGISTRATION_DOMAIN_WHITELIST=$(PENPOT_REGISTRATION_DOMAIN_WHITELIST) envsubst <./kubernetes.manifest.yaml | kubectl apply --namespace $(NAMESPACE) -f -

reload-secrets:
	PENPOT_DOMAIN=$(PENPOT_DOMAIN) PENPOT_REGISTRATION_DOMAIN_WHITELIST=$(PENPOT_REGISTRATION_DOMAIN_WHITELIST) envsubst <./secrets.yaml | kubectl apply --namespace $(NAMESPACE) -f -
	kubectl delete pod -n $(NAMESPACE) -lapp=penpot-backend
	kubectl delete pod -n $(NAMESPACE) -lapp=penpot-frontend
	kubectl delete pod -n $(NAMESPACE) -lapp=penpot-exporter

purge:
	PENPOT_DOMAIN=$(PENPOT_DOMAIN) PENPOT_REGISTRATION_DOMAIN_WHITELIST=$(PENPOT_REGISTRATION_DOMAIN_WHITELIST) envsubst <./secrets.yaml | kubectl delete --namespace $(NAMESPACE) -f -
	PENPOT_DOMAIN=$(PENPOT_DOMAIN) PENPOT_REGISTRATION_DOMAIN_WHITELIST=$(PENPOT_REGISTRATION_DOMAIN_WHITELIST) envsubst <./kubernetes.manifest.yaml | kubectl delete --namespace $(NAMESPACE) -f -
