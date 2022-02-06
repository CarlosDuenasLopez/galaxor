FROM julia:latest

COPY ./ ./

RUN julia install.jl

CMD julia main.jl