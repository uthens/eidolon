// Ideally a Pod. For now a file.

func delayToMainThread(delay:Double, closure:()->()) {
    dispatch_after (
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}