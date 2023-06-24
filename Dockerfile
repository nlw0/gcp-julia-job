# Use the official Julia Docker image with Debian
FROM julia:1.9.1-bullseye

RUN useradd -ms /bin/bash app
USER app

# Careful: HOME is set by GCP as `/home` during runtime and is `/root` during build.
ENV HOME=/home/app
WORKDIR $HOME

# Install JSON module
RUN julia -t auto -e 'using Pkg; Pkg.add("JSON"); Pkg.build()'

COPY main.jl .
CMD exec julia main.jl
