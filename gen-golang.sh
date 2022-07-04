mkdir ./proto-gen-golang
mkdir ./proto-deps

pushd ./proto-deps
git clone https://github.com/cncf/xds.git cncf-xds
git clone https://github.com/envoyproxy/protoc-gen-validate.git
git clone https://github.com/googleapis/googleapis.git
git clone https://github.com/census-instrumentation/opencensus-proto.git
git clone https://github.com/open-telemetry/opentelemetry-proto.git
git clone https://github.com/prometheus/client_model.git ./prometheus_client_model
popd

protoc --proto_path=./proto-deps/prometheus_client_model --proto_path=./proto-deps/opentelemetry-proto --proto_path=./proto-deps/opencensus-proto/src --proto_path=./proto-deps/protoc-gen-validate --proto_path=./proto-deps/cncf-xds --proto_path=./proto-deps/googleapis --go_out=./proto-gen-golang --proto_path=. $(find ./ -iname "*proto" | grep -v './proto-deps')
