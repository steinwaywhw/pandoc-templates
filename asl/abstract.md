---
title: Sample Title
author:
  - name:        Hongwei Xi and Hanwen Wu
    affiliation: Dept. of Comp. Sci., Boston Univ.
    address:     111 Cummington Mall, Boston MA, US
    email:       hwxi,hwwu@cs.bu.edu
classoption:
  - bsl
  - meeting
  - bibalpha
bibliography: ./library
bibstyle: asl
bibstyleoption: bibalpha
---

Session types offer a type-based discipline for enforcing communication protocols in distributed programming. We have previously formalized simple session types in the setting of multi-threaded $\lambda$-calculus with linear types. In this work, we build upon our earlier work by presenting a form of dependent session types (of DML-style). The type system we formulate provides linearity and duality guarantees with no need for any runtime checks or special encodings. Our formulation of dependent session types is the first of its kind, and it is particularly suitable for practical implementation. As an example, we describe one implementation written in ATS that compiles to an Erlang/Elixir back-end. \cite{Xi:2017wv}