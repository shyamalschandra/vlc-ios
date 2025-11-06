# VLC-iOS Documentation

This directory contains LaTeX documentation for the VLC-iOS project.

## Files

- **vlc-ios-paper.tex**: Academic-style paper about VLC-iOS, covering architecture, features, and technical implementation
- **vlc-ios-presentation.tex**: Beamer presentation about VLC-iOS for conferences, meetups, or educational purposes

## Building the Documents

### Prerequisites

Install LaTeX distribution:
- **macOS**: `brew install --cask mactex` or `brew install basictex`
- **Linux**: `sudo apt-get install texlive-full` (Ubuntu/Debian)
- **Windows**: Install MiKTeX or TeX Live

### Building the Paper

```bash
cd doc
pdflatex vlc-ios-paper.tex
bibtex vlc-ios-paper  # If using bibliography
pdflatex vlc-ios-paper.tex
pdflatex vlc-ios-paper.tex  # Run twice for references
```

### Building the Presentation

```bash
cd doc
pdflatex vlc-ios-presentation.tex
```

Or use XeLaTeX for better font support:
```bash
xelatex vlc-ios-presentation.tex
```

## Paper Topics Covered

1. Introduction and Project Overview
2. Architecture (Core Components, Swift-Objective-C Interoperability)
3. Recent Enhancements:
   - CarPlay Audio Enhancements
   - Focus Mode Integration
   - Home Screen Widgets
   - Live Activities
   - iCloud Synchronization
4. Technical Challenges and Solutions
5. User Experience Features
6. Open Source Model
7. Development Workflow
8. Future Directions

## Presentation Topics Covered

1. Overview and Platform Support
2. Architecture
3. Recent Enhancements (detailed slides for each)
4. Technical Implementation Examples
5. Development Challenges
6. User Experience
7. Open Source Model
8. Future Directions
9. Resources and Q&A

## Customization

Both documents can be customized:
- Modify author information
- Add/remove sections
- Update feature descriptions
- Add figures/diagrams
- Customize styling

## License

These documents are provided under the same license as the VLC-iOS project (GPLv2+ and MPLv2).

