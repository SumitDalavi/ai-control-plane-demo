.PHONY: infra-up up wait demo verify down test benchmark

infra-up:
	docker compose -f ../docker-compose.infra.yml up -d postgres redis prometheus

up:
	docker compose up --build -d

wait:
	sleep 5

demo:
	bash demo/run_demo.sh

verify:
	bash demo/verify.sh

down:
	docker compose down
	docker compose -f ../docker-compose.infra.yml down

test:
	echo "Running local unit tests..."
	npm test --prefix ../nhi-agent-access-governance/registry-api
	npm test --prefix ../llm-cost-autopilot
	npm test --prefix ../semantic-llm-cache

benchmark:
	bash benchmarks/run.sh
