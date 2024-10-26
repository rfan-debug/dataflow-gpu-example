# dataflow-gpu-example

+ A deploy-able docker image example to run inference on dataflow with GPU.

**Disclaimer**: this is just a runnable example. Cannot guarantee it is the most efficient way.

## Brief introduction

Our goal is to build a dataflow Flex template so that we can package the dataflow pipeline for production deployment.
For example, this packaged pipeline will be allowed to be executed by GCP Workflow.

There are three steps to build the flex template container.

1. Build your code logic and dependencies into a docker image. (`build_deps.yaml`). To validate this step is successful,
   you can try to execute the job on dataflow runner with command like the following to validate your job is launchable
   from your terminal.

```shell
python main.py
--runner=DataflowRunner \
--project=$PROJECT_ID \
--region=$_REGION \
--job_name=$_JOB_NAME \
--temp_location=$_TEMP_LOCATION \
--sdk_container_image="us-central1-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY}/${_RUNNER_IMAGE}" \
--machine_type=n1-highmem-8 \
--experiment="worker_accelerator=type:nvidia-l4;count:1;install-nvidia-driver" \
--experiment=use_runner_v2 \
--experiment=no_use_multiple_sdk_containers \
--number_of_worker_harness_threads=1 \
--disk_size_gb=50 \
--sdk_location=container
# Continue with your job parameters
```

2. Use your above base deps image and dataflow-template launcher to build a flex base image. (`build_flex_base.yaml`)

3. Use your both images above to build a launch-able Dataflow flex template. (`build_flex.yaml`)

## Refernece

+ [Dataflow flex template](https://cloud.google.com/dataflow/docs/guides/templates/using-flex-templates)
+ [Image Captioning on huggingface](https://huggingface.co/docs/transformers/main/en/tasks/image_captioning)