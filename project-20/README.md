# Project 20 — Provisioners

## 🎯 What You Will Learn
- `local-exec` provisioner — run commands locally
- `remote-exec` provisioner — run commands on a remote server
- `file` provisioner — copy files to a remote server
- Provisioner `when = destroy`
- Why provisioners are a **last resort**

## 📖 Exam Domain
- Domain 8: Provisioners

---

## 🧠 Theory: What are Provisioners?

Provisioners execute scripts or commands **during resource creation or destruction**. They exist to handle cases where Terraform's declarative approach isn't enough.

---

## 🧠 Theory: local-exec

Runs a command on the **machine running Terraform** (not the remote server):

```hcl
provisioner "local-exec" {
  command = "echo ${self.public_ip} >> known_hosts.txt"
}
```

Use `self` to reference the parent resource's attributes inside a provisioner.

---

## 🧠 Theory: remote-exec

Runs commands **on the remote server** via SSH (Linux) or WinRM (Windows):

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y nginx"
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}
```

---

## 🧠 Theory: file Provisioner

Copies files to the remote server:

```hcl
provisioner "file" {
  source      = "configs/app.conf"
  destination = "/etc/app/app.conf"

  connection {
    type = "ssh"
    # ...
  }
}
```

---

## 🧠 Theory: Destroy-Time Provisioners

Run when the resource is **destroyed**:

```hcl
provisioner "local-exec" {
  when    = destroy
  command = "curl -X DELETE https://api.example.com/deregister/${self.id}"
}
```

---

## 🧠 Theory: Provisioners are a LAST RESORT

HashiCorp says: **use provisioners only as a last resort**.

Problems with provisioners:
- Not idempotent — re-runs can break things
- Failures don't update state cleanly
- Harder to test
- Tightly couple configuration to provisioning

**Prefer instead:**
- AWS user_data for EC2 bootstrap
- AWS Systems Manager (SSM)
- Packer to build pre-configured AMIs
- Ansible for configuration management (called separately)

---

## 🚀 How to Run

```bash
# The remote-exec requires a real key pair
# For local-exec only testing, remove remote-exec block first

terraform init
terraform plan
terraform apply   # local-exec runs immediately
cat provisioned.log

terraform destroy  # destroy provisioner runs
```

## ✅ Exam Tips
> `local-exec` runs on the Terraform machine  
> `remote-exec` runs on the remote server (needs SSH/WinRM)  
> `self` references the resource the provisioner belongs to  
> `when = destroy` runs on resource destruction  
> Provisioners are a **last resort** — prefer cloud-native alternatives  
> Provisioner failures don't roll back the resource  

## ➡️ Next Project
Project 21 covers moved blocks, check blocks, and preconditions/postconditions.
