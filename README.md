## Corda Network on Kubernetes
This tool will help to setup Corda Network (Open Source v4.5) by using Kubernetes.


### Installation Guide
Setup Kubernetes cluster [Ref Link](https://medium.com/@dinesh.rivankar/kubernetes-cluster-on-rhel-7-e3621823ad07)


**# Step 1**

clone this repo on Master node of Kubernetes and add *'corda-tools-network-bootstrapper-4.5.jar'* under network-bootstrapper directory.

Now edit the .env file to add details related of the docker image  and hostnames for each participants.
```bash
DOCKER_IMAGE_NAME=masterops/corda-os-node:4.5
NOTARY_HOSTNAME=notary_host_name
PARTYA_HOSTNAME=partya_host_name
PARTYB_HOSTNAME=partyb_host_name
```
Use below command to find the hostnames for all the worker nodes, Name column in the output is the hostname for the node.
```bash
    kubectl get nodes
```

**# Step 2**

Network Bootstrapper
```bash
    cd network-bootstrapper/
    ./bootstrap.sh
```
Tool makes use of Cluster IP concept of Kubernetes, this IP can be changed in node.conf and respected yaml files for Kubernetes deployment.

**# Step 3**

Deploy Network

Before deploying the network, add the CorDapp jar files in cordapps directory of the repository. These jar files will be mounted in the container. For exploration add IOU jar files. Use [CorDapp tutorial](https://docs.corda.net/docs/corda-os/4.5/tutorial-cordapp.html) for building IOU jar.

```bash
    ./deploye.sh
```

**# Step 3**

Test Network

After successful execution of the script, there will be pods and containers created for each participants.

Now login to PartyA VM and ssh to the node shell.

```bash
    docker exec -it <<container-id>> bash
    ssh -p 2222 localhost -l user1
```

Invoke a transaction with PartyB.   

```bash
    start IOUFlow iouValue: 99, otherParty: "O=PartyB,L=New York,C=US"
```

Output

```bash
 ✓ Starting
          Requesting signature by notary service
              Requesting signature by Notary service
              Validating response from Notary service
     ✓ Broadcasting transaction to participants
▶︎ Done
Flow completed with result: kotlin.Unit
```

Query a transaction 
```bash
    run vaultQuery contractStateType: com.template.states.IOUState
```

Output
```bash
states:
- state:
    data: !<com.template.states.IOUState>
      value: 99
      lender: "O=PartyA, L=London, C=GB"
      borrower: "O=PartyB, L=New York, C=US"
    contract: "com.template.contracts.IOUContract"
    notary: "O=Notary, L=London, C=GB"
    encumbrance: null
    constraint: !<net.corda.core.contracts.SignatureAttachmentConstraint>
      key: "aSq9DsNNvGhYxYyqA9wd2eduEAZ5AXWgJTbTEw3G5d2maAq8vtLE4kZHgCs5jcB1N31cx1hpsLeqG2ngSysVHqcXhbNts6SkRWDaV7xNcr6MtcbufGUchxredBb6"
  ref:
    txhash: "5E8EC316D506A3A129FCD7C52F4AA8A60F05C039FF5EEB44A9CF40F92E65075E"
    index: 0
statesMetadata:
- ref:
    txhash: "5E8EC316D506A3A129FCD7C52F4AA8A60F05C039FF5EEB44A9CF40F92E65075E"
    index: 0
  contractStateClassName: "com.template.states.IOUState"
  recordedTime: "2020-06-29T06:04:42.932Z"
  consumedTime: null
  status: "UNCONSUMED"
  notary: "O=Notary, L=London, C=GB"
  lockId: null
  lockUpdateTime: null
  relevancyStatus: "RELEVANT"
  constraintInfo:
    constraint:
      key: "aSq9DsNNvGhYxYyqA9wd2eduEAZ5AXWgJTbTEw3G5d2maAq8vtLE4kZHgCs5jcB1N31cx1hpsLeqG2ngSysVHqcXhbNts6SkRWDaV7xNcr6MtcbufGUchxredBb6"
totalStatesAvailable: -1
stateTypes: "UNCONSUMED"
otherResults: []
```

**# Step 5**

Reset Network
```bash
     ./reset.sh
```
