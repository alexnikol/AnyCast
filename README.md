# **Podcats**
For non-commercial use

> **Multiplatform podcast application**

[![Deploy Podcats iOS](https://github.com/alexnikol/Podcats/actions/workflows/Deploy.yml/badge.svg?branch=deploy%2Fdeploy_podcast_iphone_ios)](https://github.com/alexnikol/Podcats/actions/workflows/Deploy.yml) [![CI macOS](https://github.com/alexnikol/Podcats/actions/workflows/CI_macOS.yml/badge.svg)](https://github.com/alexnikol/Podcats/actions/workflows/CI_macOS.yml) [![CI iOS](https://github.com/alexnikol/Podcats/actions/workflows/CI_iOS.yml/badge.svg)](https://github.com/alexnikol/Podcats/actions/workflows/CI_iOS.yml)

[![Test Coverage](https://api.codeclimate.com/v1/badges/8162b7af4639d0871449/test_coverage)](https://codeclimate.com/github/alexnikol/Podcats/test_coverage)

![Large logo](Resources/large_icon.svg)

## Table Of Content

- [Tech Stack](#tech_stack)
- [Project Diagram](#project_diagram)
- [Project Structure](#project_structure)
- [Delivery Workflow](#delivery_workflow)
- [Automation Testing](#testing)
- [License](#license)
- [Links](#links)

# Tech Stack
Podcats is the multiplatform convenient podcast application. The project relies on automated testing, clean architecture, automation deployment, and TDD. The main focus is testable and reusable code across different apple platforms.

**`iPhone(iOS)`** - Swift, UIKit, Combine, MVP, cross-platform frameworks from core project.
Target: Podcats

**`iPad(iOS)`** - Swift, SwiftUI, Combine, MVVM, cross-platform frameworks from core project
Target: Podcats

**`Widget(iOS)`** - Swift, SwiftUI, Combine, cross-platform frameworks from core project
Target: Podcats

**`Core project`** - Swift, cross-platform Apple reusable frameworks, TestFlight, TDD (tests first), Unit, Integration, Acceptance, Snapshot testing strategies. CI/CD Github Actions (automated testing, deployment, Code Climate, test coverage metrics).
`Modular design with vertical and horizontal slice architecture, Universal abstractions based on Combine. Bunch of isolated modular frameworks for fast and quality testing and development`


# Project Diagram

# Project Structure

# Delivery Workflow

# Automation Testing

# License

# Links



## **User Roles**
**User Role** | **Description**
------------- | -------------
**`Client`**  | User of the app
**`Podcast`**  | Channel of Shows
**`Episode`**  | Single show
**`Genre`**  | Genre of Podcast

## **Features List**
**Feature**                 | **Link on documentation (specs, use cases)**
--------------------------- | -----------------------------------------------
**`Podcasts Genres List`** | [Genres List specs](PodcastsComponents/PodcastsGenresList%20Feature/PodcastsGenresList/README.md)