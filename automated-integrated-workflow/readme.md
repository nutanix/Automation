# Building automated workflows leveraging Nutanix CALM Runbooks, Prism Pro Playbooks, and integration with other application like Jira or ServiceNow

This is an example to design and build an automated workflow that could be triggered automatically and upgrade VM resources on getting approval from the authorized body. In this case it leverages Prism Pro Playbooks with a manual trigger (for demonstration) attached to any VM integrated with CALM runbooks and third party application like Atlassian Jira to get approval and decision making process whether to proceed with upgrade or not. Other automatic triggering is possible through available triggers like alerts, events, time based or a webhook for different entities of Prism. 

Here is the overview of the workflow 
![conceptual overview](/automated-integrated-workflow/blobs/approve-auto-update-vm-workflow.png?raw=true)

## Breakdown and installation of the components of the workflow:
 
 - A triggering playbook: A Prism Pro playbook is needed to automatically or manually trigger some actions based sourcing from any entities. It would provide decoupled approach from the playbook for independent management of versatile integration logic and freedom of customization for the workflow decision making process. Our sample playbook (playbooks-trigger_runbook.pbk) is attached with a manual trigger from any VM running in Prism central. Import the playbook in prism central then make sure to enable it as follows. By default it remains disabled.
![architectural overview](/automated-integrated-workflow/blobs/enable_playbook.png?raw=true)
 
 - Runbook: A runbook is constructed in order to be invoked from a REST api action from the playbook. Import the CALM runbook (get_Approval.json). Change the variable waitUntilMinutes in the configuration section to adjust the waiting time until it gets an approval or deny on the Jira ticket. Until, a decision has been made on the ticket the process would keep trying every minute until it reaches the defined waiting limit in minutes. Otherwise, it will do nothing. Update the other variables and credentials for your environment. The process would call back the following playbook as a webhook regardless. 
 
 ![auto upgrade vm](/automated-integrated-workflow/blobs/get_approval_rb.png?raw=true)

 - A callback playbook: Playbook (playbook-auto_upgrade_resources_v2.pbk) has trigger type webhook which allows it to be called from the runbook in previous step. The playbook would either upgrade the VM in concern if the request was approved on the Jira ticket otherwise it will skip. It will notify the system admin via email regardless of the outcome of the decision.

![auto upgrade vm](/automated-integrated-workflow/blobs/auto_upgrade_resources_v2.png?raw=true)

 From a runbook task a sample request to trigger the upgrade playbook would look something like this. 
 ```json
    {
    "trigger_type": "incoming_webhook_trigger",
    "trigger_instance_list": [{
        "webhook_id": "@@{webhookId}@@",
        "string1": "JIRA ticket- vm upgrade",
        "integer1": decision,
        "entity1": "{\"type\":\"vm\",\"name\":\"Xplay-loc-test\",\"uuid\":\"fdbb7d56-1ec7-4655-bb25-aea209cdd05f\"}"
    }]
    }
```

It supplies 
 - the webhook_id for the corresponding webhook of the playbook. Grab the id from the summary page after importing the playbook (palybook-auto_upgrade_resources_v2.pbk) into your prism central.
 - name of the Jira issue as string1
 - a decision variable whether or not to update either by "1" or "0" with the field integer1
 - the vm to upgrade as entity1

 if the request was denied the runbook would set decision 0 and the called playbook would execute the first branch and just notify the requestor the decision, otherwise it will go ahead and perform the upgrade on the VM in the second branch.

## Test it out
