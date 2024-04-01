help: ## List allowed targets
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf " \033[1;35m%-20s\033[0m %s\n", $$1, $$2}'
	@echo 

start: cleanup generate-keys generate-certs ## Start the environment to showcase the Stevedore features
	docker compose -p demo-stevedore up -d --build registry gitserver stevedore

cleanup: cleanup-certs ## Cleanup the environment
	docker compose -p demo-stevedore down -v --remove-orphans --timeout 3

generate-keys: cleanup-keys ## Generate an SSH key pair required to autheneticate to Git server
	@docker compose -p demo-stevedore run --rm openssh -t rsa -q -N "password" -f id_rsa -C "apenella@stevedore.test"

cleanup-keys: ## Cleanup the SSH key pair
	@docker compose -p demo-stevedore run --rm --entrypoint /bin/sh openssh -c 'rm -rf $$(ls)'

generate-certs: cleanup-certs ## Generate certificate required Docker registry
	@docker compose -p demo-stevedore run --rm openssl req -newkey rsa:2048 -nodes -keyout stevedore.test.key -out stevedore.test.csr -config /root/ssl/stevedore.test.cnf
	@docker compose -p demo-stevedore run --rm openssl  x509 -signkey stevedore.test.key -in stevedore.test.csr -req -days 365 -out stevedore.test.crt -extensions req_ext -extfile /root/ssl/stevedore.test.cnf

cleanup-certs: ## Cleanup certificates
	@docker compose -p demo-stevedore run --rm --entrypoint /bin/sh openssl -c 'rm -rf $$(ls)'

status: ## Show the services status
	docker compose -p demo-stevedore ps

start-and-attach: start ## Start the environment and attach to 'stevedore' service container
	docker compose -p demo-stevedore run --rm stevedore sh

attach: ## Attach to the 'stevedore' service container
	docker compose -p demo-stevedore run --rm --build stevedore sh

start-and-demo: start ## Starts the environment and run the demo
	docker compose -p demo-stevedore run --rm --build stevedore

demo: ## Run the demo. It requires to have the environment up and running
	docker compose -p demo-stevedore run --rm --build stevedore
