mistral-demo
============

Mistral Demo via Vagrant and Virtualbox


## Hints
    mistral workbook-create cycle "cycle decs" "tags" cycle.yaml
    mistral  workbook-upload-definition cycle  cycle.yaml 
    mistral execution-create cycle createVM cycle.json 
    
* For SSH to work, manually `ssh 172.16.80.230` to add cirros' image public to the list of known hosts.
