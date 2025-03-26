---
title: Authenticating EKS to Google Cloud
description: This article covers the use case of authenticating a kubernetes workload in AWS using IRSA or EKS Pod Identity to access resources in Google Cloud. The example use case will involve a Golang application across two kubernetes clusters in different AWS accounts accessing the same Google Cloud Storage bucket.
keywords:  golang,AWS,GCP,IRSA,Workload Identity Pool,EKS,GKE
---
# Authenticating EKS to Google Cloud

This article covers the use case of authenticating a kubernetes workload
in AWS using IRSA or EKS Pod Identity to access resources in Google Cloud. The
example use case will involve a Golang application across two kubernetes
clusters in different AWS accounts accessing the same Google Cloud Storage bucket.

It is assumed that your workload in the kubernetes clusters are making use of
IRSA or EKS Pod Identity in order to automatically associate an AWS IAM role
with the workload's kubernetes ServiceAccount.

This is a diagram demonstrating the relationships between the clouds:

```
┌─────────────────────────────┐     ┌───────────────────────────────┐
│AWS Account one         ┌───┐│     │                  Google Cloud │
│                 ┌─────►│IAM││     │┌───────────────────────────┐  │
│             IRSA│      └───┘│  ┌──►│Workload Identity Providers│  │
│┌────────────────┼──────────┐│  │  │└─┬─────────────────────────┘  │
││kubernetes      ▼          ││  │  │  │attributes                  │
││ ┌───┐    ┌──────────────┐ ││  │  │┌─▼────────────────────┐       │
││ │Pod├───►│ServiceAccount├─┼┼──┤  ││Workload Identity Pool│       │
││ └───┘    └──────────────┘ ││  │  │└─┬────────────────────┘       │
│└───────────────────────────┘│  │  │  │principleSet                │
└─────────────────────────────┘  │  │┌─▼─────────────┐ IAM  ┌──────┐│
                                 │  ││Service Account├─────►│Bucket││
┌─────────────────────────────┐  │  │└───────────────┘      └──────┘│
│AWS Account two         ┌───┐│  │  └───────────────────────────────┘
│                 ┌─────►│IAM││  │
│             IRSA│      └───┘│  │
│┌────────────────┼──────────┐│  │
││kubernetes      ▼          ││  │
││ ┌───┐    ┌──────────────┐ ││  │
││ │Pod├───►│ServiceAccount├─┼┼──┘
││ └───┘    └──────────────┘ ││
│└───────────────────────────┘│
└─────────────────────────────┘
```

## Table of Contents

