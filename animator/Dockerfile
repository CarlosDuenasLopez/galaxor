FROM julia:latest

EXPOSE 80

ENV INDOCKER=true

COPY ./ ./
RUN julia install.jl

CMD julia animator.jl