This is a very basic dbt project that aims to demonstrate how dbt could be orchestrated with GitHub Actions.

# Workflows

There are 2 custom workflows created for this project:
- [Transformations](./.github/workflows/transformations.yml)
- [CI Pipeline](./.github/ci-pipeline.yml)

## Transformations
This is the main pipeline that dbt uses for its runs. It runs 30 minutes after every 6th hour, as evident by the Cron configuration. It can also be triggered manually. 

### Production Run

This job installs dependencies, runs and tests dbt models and caches any artefacts needed for other jobs and workflows. If a step fails, the job sends out a Slack notification:

1. Caches Python to optimize performance
2. Installs Pipenv dependencies
3. Runs `dbt deps`
4. Runs `dbt build`
5. Runs `dbt docs generate`
6. If no steps have failed
   
     6.1. Clears any previously cached artefacts
   
     6.2. Caches the run artefacts from this run
   
8. If a step has failed, sends a Slack notification using an incoming webhook
    
### Update documentation
This job is only triggered upon successful completion of the `Production Run` job. It restores the artefacts cached in the preceding job and commits them to a different branch `gh-pages`, which allows for a documentation site to be built via GitHub Pages with the latest production DAG.

## CI Pipeline
This workflow is only triggered when a Pull Request is created. It works as follows:

1. Restores the `manifest.json` file needed for a Slim CI run
2. Installs Pipenv and dependencies
3. Runs new and updated models via `dbt build` in a schema called `CI_SCHEMA`
4. Executes a macro calles `post_ci_cleanup` which drops the `CI_SCHEMA` if the run has succeeded (and leaves it undropped for further investigation in case it fails).
