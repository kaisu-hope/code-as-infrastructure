cd ..\..\vagrant-vm-env\k8s\
vagrant ssh master
kubectl create ns gitlab
kubectl appy -f redis.yaml
sudo mkdir -p /data/nfs/gitlab/pg_data
kubectl appy -f postgresql.yaml
sudo mkdir -p /data/nfs/gitlab/data
kubectl appy -f gitlab.yaml
