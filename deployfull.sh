tffolder=full

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

#helm upgrade --install gitlab gitlab/gitlab \
#  --namespace gitlab \
#  --timeout 600s \
#  --set global.edition=ce \
#  --set global.hosts.domain=alexeynikitin.me \
#  --set certmanager-issuer.email=nikitinay@gmail.com \
#  --set postgresql.install=false \
#  --set global.psql.host=rdscluster.c4fx3lggt1qo.eu-west-2.rds.amazonaws.com \
#  --set global.psql.database=gitlabhq_production \
#  --set global.psql.password.secret=gitlab-postgresql-password \
#  --set global.psql.username=gitlab \
#  --set global.psql.password.key=db_pass1 \
#  --set redis.install=false \
#  --set global.redis.host=redis-gitlab.gtyfeh.ng.0001.euw2.cache.amazonaws.com \