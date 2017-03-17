# SLaM Notes

**Aims**  
Understanding where we are and what needs to be done with:
+ Status of the current application
+ Application architecture
+ Integration with ePJS
+ Interoperability standards
+ Deployment plan

KHP = Kings Health Partnership


## Timelines
+ **20th March:** Running a closed beta (so Mindwave need to ensure there is continuous engagement)
+ **Mid April:** Soft launch
+ **Mid May:** Launch of the service to collect more data
+ **Early July:** Full launch

## ePJS
+ Started looking at deployment of API on UAT environment 2 weeks ago
  + Quite problematic so far
  + Until at least mid April
  + API is pretty minimal
+ For the 'old' Healthlocker, XML coming out of ePJS is encrypted and then sent to Microsoft who then send it to Healthlocker
+ **Agreed:** @nelsonic and Garry will work together to understand how Garry can push the unencrypted ePJS XML directly to an endpoint in the 'new' Healthlocker
+ Realistic timetable to be able to connect to 'real' data
+ 14th April: Accessing real patient data in UAT environment
  + From API: 4 fields that allow us to connect to SLaM users
  + From XML: At least coping strategies and goals
  + For clinician access: Direct lookup on the database

## Azure
+ **Action:** Check PostgresSQL can be used as the database layer within the PaaS layer of Azure
+ **Action:** @nelsonic to get together with infrastructure team (Stewart)
+ Answer on how to do this in the easiest and most scalable way + what the indicative costs are before the meeting on the 28th


## General security
+ Key buzzword is 'open standards'
+ Emphasise patients assume that all data is unified in one place, segregation of data is only a concern for NHS Trusts
  + **Action:** @nelsonic to start off a one-pager on this and SLaM to add 'huggy fluffy' parts
+ Open source
  + Empower Trusts

## Interoperability with other Trust systems
+ Oxleys have _'Rio'_ instead of ePJS
  + Note: Not all systems have the same fields so some data translation may be required
    + Disparate data sources all also have different standards
+ Current groundswell: All suppliers to the NHS are currently signing up to Inter-open standards and they *have* to provide APIs to their clients

## Roadmap
+ Bring in discharge summary (less problematic than access to letters/documents from ePJS because doctors write these without thinking the doctors will ever access them)
