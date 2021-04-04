tffolder=eksonly

cd ./$tffolder
terraform init
terraform plan
terraform apply -auto-approve
cd ..

tfState=./$tffolder/terraform.tfstate

nodeARN=$(cat "$tfState" | jq -r '. | .resources[]? | select(.type=="aws_iam_role") | select(.name=="node") | .instances[]? | .attributes.arn')

cat <<EOF >./configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${nodeARN}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOF

export KUBECONFIG=./$tffolder/cluster.kube-config
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl apply -f ./configmap.yaml

kubectl create ns gitlab

helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --namespace gitlab \
  --set global.hosts.domain=alexeynikitin.me \
  --set certmanager-issuer.email=nikitinay@gmail.com

