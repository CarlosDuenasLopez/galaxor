FROM julia:latest

EXPOSE 80

ENV INDOCKER=true
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y cmake xorg-dev mesa-utils xvfb libgl1 freeglut3-dev 

COPY ./ ./
RUN julia install.jl



CMD julia animator.jl