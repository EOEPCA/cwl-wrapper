# Stage 1: Build stage
FROM rockylinux:9.3-minimal AS build

# Install necessary build tools & hatch 
RUN microdnf install -y curl tar && \
 curl -L https://github.com/pypa/hatch/releases/latest/download/hatch-x86_64-unknown-linux-gnu.tar.gz -o /tmp/hatch-x86_64-unknown-linux-gnu.tar.gz && \
 tar -xzf /tmp/hatch-x86_64-unknown-linux-gnu.tar.gz -C /tmp/ && chmod +x /tmp/hatch

# Stage 2: Final stage
FROM rockylinux:9.3-minimal

# Install runtime dependencies
RUN microdnf install -y --nodocs nodejs && \
    microdnf clean all

# Set up a default user and home directory
ENV HOME=/home/wrapper

# Create a user with UID 1001, group root, and a home directory
RUN useradd -u 1001 -r -g 0 -m -d ${HOME} -s /sbin/nologin \
        -c "Default CWL Wrapper User" wrapper && \
    mkdir -p /app && \
    mkdir -p /prod && \
    chown -R 1001:0 /app && \
    chmod g+rwx ${HOME} /app

# Copy the hatch binary from the build stage
COPY --from=build /tmp/hatch /usr/bin/hatch

# Switch to the non-root user
USER wrapper

# Copy the application files into the /app directory
COPY --chown=1001:0 . /app
WORKDIR /app

# Set up virtual environment paths
ENV VIRTUAL_ENV=/app/envs/wrapper
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Prune any existing environments and create a new production environment
RUN hatch env prune && \
    hatch env create prod && \
    rm -fr /tmp/* /app/.git /app/.pytest_cache

# Set the default command to run when the container starts
CMD ["bash", "-c", "source /app/envs/wrapper/bin/activate && cwl-wrapper"]
