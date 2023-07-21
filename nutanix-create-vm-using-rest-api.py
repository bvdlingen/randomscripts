# Create a VM from the Nutanix REST API

import requests

def create_vm(name, guest_os, memory_mb, num_vcpus, storage_container_uuid, network_uuid):
  """Creates a VM from the Nutanix REST API."""

  url = "https://api.nutanix.com/v2/vms"
  headers = {"Content-Type": "application/json"}
  data = {
    "description": "Provision VM through Rest API",
    "guest_os": guest_os,
    "memory_mb": memory_mb,
    "num_vcpus": num_vcpus,
    "vm_disks": [
      {
        "disk_address": {
          "device_bus": "IDE",
          "device_index": 0
        },
        "is_cdrom": True,
        "is_empty": False,
        "vm_disk_clone": {
          "disk_address": {
            "device_bus": "SCSI",
            "device_index": 0,
            "vmdisk_uuid": "6cc69233-5d74-4af3-b2d3-bb669678f7d5"
          }
        }
      },
      {
        "disk_address": {
          "device_bus": "SCSI",
          "device_index": 0
        },
        "is_cdrom": False,
        "is_empty": False,
        "vm_disk_create": {
          "size": 20000000000,
          "storage_container_uuid": storage_container_uuid
        }
      }
    ],
    "vm_nics": [
      {
        "adapter_type": "E1000",
        "network_uuid": network_uuid
      }
    ]
  }

  response = requests.post(url, headers=headers, data=json.dumps(data))

  if response.status_code == 200:
    print("VM created successfully")
  else:
    print("Error creating VM: {}".format(response.status_code))

if __name__ == "__main__":
  create_vm("REST_API_VM_bert_aka_bvdl", "Linux", 4096, 2, "03fc8013-ad6a-4b13-891c-48eaa2a53b40", "1ac88e40-e8b4-447b-beb0-7d7011c9d981")
