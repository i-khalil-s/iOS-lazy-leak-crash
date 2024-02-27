# iOS-lazy-leak-crash
Playground that exemplifies how retaining `self` by creating a strong reference to it on a lazy var (creation on demand) could cause a crash if a leak is present
