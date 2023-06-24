# Julia example for Cloud Run jobs

This is a Julia version of the [Python example](https://cloud.google.com/run/docs/quickstarts/jobs/build-create-python) for creating a Cloud Run job.

The Dockerfile makes sure that Julia packages get installed properly during the image build, preventing package management activity when starting the job. It is not really necessary, the Julia script could just install JSON as a first step.
