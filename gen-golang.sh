rm -rf ./proto-gen-golang/*

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

protoc --proto_path=./proto-deps/golang-protobuf --proto_path=./proto-deps/prometheus_client_model --proto_path=./proto-deps/opentelemetry-proto --proto_path=./proto-deps/opencensus-proto/src --proto_path=./proto-deps/protoc-gen-validate --proto_path=./proto-deps/cncf-xds --proto_path=./proto-deps/googleapis --proto_path=. --validate_out="lang=go:./proto-gen-golang" --go_out=plugins=grpc:./proto-gen-golang $(find ./ -iname "*proto" | grep -v './proto-deps')

mkdir ./proto-gen-golang/contrib
mkdir ./proto-gen-golang/github.com/envoyproxy/go-control-plane/contrib

protoc --proto_path=./proto-deps/golang-protobuf --proto_path=./proto-deps/prometheus_client_model --proto_path=./proto-deps/opentelemetry-proto --proto_path=./proto-deps/opencensus-proto/src --proto_path=./proto-deps/protoc-gen-validate --proto_path=./proto-deps/cncf-xds --proto_path=./proto-deps/googleapis --proto_path=. --validate_out=lang=go:./proto-gen-golang/contrib --go_out=plugins=grpc:./proto-gen-golang/contrib $(find ./contrib/ -iname "*proto" | grep -v './proto-deps')

mv  ./proto-gen-golang/contrib/github.com/envoyproxy/go-control-plane/envoy ./proto-gen-golang/github.com/envoyproxy/go-control-plane/contrib/envoy
rm -rf ./proto-gen-golang/contrib

find ./proto-gen-golang/github.com/envoyproxy/go-control-plane/contrib -name "*.go" | xargs -n1 -I{} sed -i 's/github.com\/envoyproxy\/go-control-plane\/envoy\/extensions/github.com\/envoyproxy\/go-control-plane\/contrib\/envoy\/extensions/g' {}

find ./proto-gen-golang/github.com/envoyproxy/go-control-plane/contrib -name "*.go" | xargs -n1 -I{} sed -i 's/github.com\/envoyproxy\/go-control-plane\/contrib\/envoy\/extensions\/transport_sockets/github.com\/envoyproxy\/go-control-plane\/envoy\/extensions\/transport_sockets/g' {}

find ./proto-gen-golang/ -name "*.go" | xargs -n1 -I{} sed -i 's/github.com\/cncf\/xds\/go\/annotations/github.com\/cncf\/xds\/go\/udpa\/annotations/g' {}
