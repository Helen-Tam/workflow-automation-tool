👉  Project: " Integrate Jenkins → Make (Integromat) → Slack + Email "
Goal: Every Jenkins pipeline run automatically notifies developers on SUCCESS or FAILURE.

1️⃣ High-level architecture
```
Jenkins Pipeline
   │
   │  (HTTP POST with build status + metadata)
   ▼
Make Webhook
   │
   ├── Slack module → send message to channel / user
   └── Email module → send email to developer
```
Why Make?
No credentials stored in Jenkins for Slack/Email
Easy branching logic (success vs failure)
Central notification logic (reusable across pipelines)
Great answer for “decoupling CI from integrations” 

2️⃣ Create the Make Scenario (Webhook)
Step 1: Webhook trigger

In Make:

Create a new scenario

Add Webhooks → Custom webhook

Click Add, name it:
jenkins_pipeline_notifications

Copy the generated Webhook URL
(we’ll use it in Jenkins)

3️⃣ Define payload contract (VERY important)

Jenkins will send structured JSON.

Example payload:
{
  "job_name": "my-app-pipeline",
  "build_number": "42",
  "status": "SUCCESS",
  "branch": "main",
  "commit": "a1b2c3d",
  "author": "helen",
  "build_url": "https://jenkins.example.com/job/my-app/42/",
  "environment": "prod"
}

👉 This “contract” is what Make relies on
👉 This is exactly how real CI/CD integrations are designed

4️⃣ Jenkins Pipeline – core integration

🔐 Security best practice

Store Make webhook URL as Jenkins credential

Type: Secret Text

ID: make-webhook-url

5️⃣ Make Scenario – routing logic
Step 1: Add Router

After the webhook:

Add Router

Create two routes:

SUCCESS

FAILURE

Filters:

SUCCESS route: status = SUCCESS
FAILURE route: status = FAILURE

6️⃣ Slack notification module
Example Slack message (FAILURE)
🚨 Jenkins Pipeline FAILED

• Job: {{job_name}}
• Build: #{{build_number}}
• Branch: {{branch}}
• Environment: {{environment}}

🔗 Build URL:
{{build_url}}

Example Slack message (SUCCESS)
✅ Jenkins Pipeline SUCCESS

• Job: {{job_name}}
• Build: #{{build_number}}
• Branch: {{branch}}

🎉 All checks passed!

7️⃣ Email notification module

Subject (FAILURE): ❌ Jenkins Build Failed – {{job_name}} #{{build_number}}
Body:
Hello,

The Jenkins pipeline has FAILED.

Job: {{job_name}}
Build: #{{build_number}}
Environment: {{environment}}

Build URL:
{{build_url}}

Please investigate.

— CI/CD System

8️⃣ Why this design is GOOD DevOps (interview gold)

You can confidently say:

Jenkins does not talk directly to Slack or Email

Jenkins only emits events

Make handles:

Notification formatting

Routing

Multiple integrations

Easy to add:

MS Teams

PagerDuty

Jira ticket creation

Zero pipeline changes needed