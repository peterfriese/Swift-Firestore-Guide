<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Discussions][discussions-shield]][discussions-url]
[![Feature Requests][featurerequest-shield]][featurerequest-url]
[![License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/peterfriese/Swift-Firestore-Guide">
    <img src="images/header.png" alt="Logo">
  </a>

  <h1 align="center">Swift & Firestore -  The Comprehensive Guide</h1>

  <p align="center">
    Code for my series about Firestore and Swift
    <br />
    <a href="https://peterfriese.dev/firestore-codable-the-comprehensive-guide"><strong>Read the article »</strong></a>
    <br />
    <br />
    <a href="https://github.com/peterfriese/Swift-Firestore-Guide/issues">Report Bug</a>
    ·
    <a href="https://github.com/peterfriese/Swift-Firestore-Guide/issues">Request Feature</a>
  </p>
</p>


<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#running">Running</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About

This project shows how to use Swift's Codable API with Firestore.


<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

To run this demo, you will need:
* Xcode 12.x
* Firebase CLI

### Installation

1. Install Xcode (see https://developer.apple.com/xcode/)
2. Install the Firebase CLI (see https://firebase.google.com/docs/cli)

### Running

You won't have to set up a Firebase project to run this sample, as it makes use of the local emulator suite.

1. First, launch the Firebase Emulator suite:
    ```bash
    $ ./start.sh
    ```
1. Open the project in Xcode
    ```bash
    $ .xed .
    ```
1. Run the iOS project on a local Simulator (so it can connect to the Firebase Emulator)


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the Apache 2 License. See `LICENSE` for more information.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/peterfriese/Swift-Firestore-Guide.svg?style=flat-square
[contributors-url]: https://github.com/peterfriese/Swift-Firestore-Guide/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/peterfriese/Swift-Firestore-Guide.svg?style=flat-square
[forks-url]: https://github.com/peterfriese/Swift-Firestore-Guide/network/members
[stars-shield]: https://img.shields.io/github/stars/peterfriese/Swift-Firestore-Guide.svg?style=flat-square
[stars-url]: https://github.com/peterfriese/Swift-Firestore-Guide/stargazers
[issues-shield]: https://img.shields.io/github/issues/peterfriese/Swift-Firestore-Guide.svg?style=flat-square
[issues-url]: https://github.com/peterfriese/Swift-Firestore-Guide/issues
[license-shield]: https://img.shields.io/github/license/peterfriese/Swift-Firestore-Guide.svg?style=flat-square
[license-url]: https://github.com/peterfriese/Swift-Firestore-Guide/blob/master/LICENSE.txt

[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/peterfriese
[product-screenshot]: images/screenshot.png

[swift-shield]: https://img.shields.io/badge/swift-5.3-FA7343?logo=swift&color=FA7343&style=flat-square
[swift-url]: https://swift.org

[xcode-shield]: https://img.shields.io/badge/xcode-12.5_beta-1575F9?logo=Xcode&style=flat-square
[xcode-url]: https://developer.apple.com/xcode/

[featurerequest-url]: https://github.com/peterfriese/Swift-Firestore-Guide/issues/new?assignees=&labels=type%3A+feature+request&template=feature_request.md
[featurerequest-shield]: https://img.shields.io/github/issues/peterfriese/Swift-Firestore-Guide/feature-request?logo=github&style=flat-square
[discussions-url]: https://github.com/peterfriese/Swift-Firestore-Guide/discussions
[discussions-shield]: https://img.shields.io/badge/discussions-brightgreen?logo=github&style=flat-square