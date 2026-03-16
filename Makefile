ENV_FILE ?= .env
-include $(ENV_FILE)
export

clean  :; forge clean

build:; forge build

test :; forge test

snapshot :; forge snapshot

format :; forge fmt

SENDER_ARGS ?= --private-key $(PRIVATE_KEY)
COMMON_ARGS := --rpc-url $(RPC_URL) $(SENDER_ARGS) -vvvvv
VERIFY_ARGS := --verify --verifier etherscan --etherscan-api-key $(ETHERSCAN_API_KEY)

pre-deploy:
	@forge script script/PreDeploy.s.sol:PreDeploy --rpc-url $(RPC_URL) -vvvvv

deploy:
	@forge script script/Deploy.s.sol:Deploy $(COMMON_ARGS) --broadcast

deploy-verify:
	@forge script script/Deploy.s.sol:Deploy $(COMMON_ARGS) --broadcast $(VERIFY_ARGS)

deploy-dry-run:
	@forge script script/Deploy.s.sol:Deploy $(COMMON_ARGS)

upgrade:
	@forge script script/Upgrade.s.sol:Upgrade $(COMMON_ARGS) --broadcast

upgrade-verify:
	@forge script script/Upgrade.s.sol:Upgrade $(COMMON_ARGS) --broadcast $(VERIFY_ARGS)

verify-factory:
	@forge verify-contract $(FACTORY_ADDRESS) src/p2pSsvProxyFactory/P2pSsvProxyFactory.sol:P2pSsvProxyFactory \
		--verifier etherscan --chain $(CHAIN_ID) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--constructor-args $$(cast abi-encode "constructor(address,address,address)" $(P2P_ORG_UNLIMITED_ETH_DEPOSITOR) $(FEE_DISTRIBUTOR_FACTORY) $(REFERENCE_FEE_DISTRIBUTOR)) \
		--watch

verify-proxy-impl:
	@forge verify-contract $(PROXY_IMPL_ADDRESS) src/p2pSsvProxy/P2pSsvProxy.sol:P2pSsvProxy \
		--verifier etherscan --chain $(CHAIN_ID) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--watch

verify-beacon:
	@forge verify-contract $(BEACON_ADDRESS) src/proxy/P2pUpgradeableBeacon.sol:P2pUpgradeableBeacon \
		--verifier etherscan --chain $(CHAIN_ID) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--constructor-args $$(cast abi-encode "constructor(address,address)" $(PROXY_IMPL_ADDRESS) $(DEPLOYER_ADDRESS)) \
		--watch

verify-all: verify-factory verify-proxy-impl verify-beacon
