# FROM redis
FROM julia:latest
# ENV MYREDIS=redis
COPY install.jl ./
COPY ./ ./
RUN julia install.jl

CMD julia registry.jl