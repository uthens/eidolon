import UIKit
import Moya
import RxSwift

// We abstract this out so that we don't have network models, etc, aware of the view controller.
// This is a "source of truth" that should be referenced in lieu of many independent variables. 
protocol FulfillmentController: class {
    var bidDetails: BidDetails { get set }
    var auctionID: String! { get set }
}

class FulfillmentNavigationController: UINavigationController, FulfillmentController {

    // MARK: - FulfillmentController bits

    /// The the collection of details necessary to eventually create a bid
    var bidDetails = BidDetails(saleArtwork:nil, paddleNumber: nil, bidderPIN: nil, bidAmountCents:nil)
    var auctionID: String!
    var user: User!

    var provider: Provider!

    // MARK: - Everything else

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let destination = segue.destinationViewController as? PlaceBidViewController {
            destination.provider = provider
        }
    }

    func reset() {
        let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = storage.cookies
        cookies?.forEach { storage.deleteCookie($0) }
    }

    func updateUserCredentials(loggedInProvider: Provider) -> Observable<Void> {
        let endpoint: ArtsyAPI = ArtsyAPI.Me
        let request = loggedInProvider.request(endpoint).filterSuccessfulStatusCodes().mapJSON().mapToObject(User)

        return request
            .doOnNext { [weak self] fullUser in
                guard let me = self else { return }

                me.user = fullUser

                let newUser = me.bidDetails.newUser

                newUser.email.value = me.user.email
                newUser.password.value = "----"
                newUser.phoneNumber.value = me.user.phoneNumber
                newUser.zipCode.value = me.user.location?.postalCode
                newUser.name.value = me.user.name
            }
            .logError("error, the authentication for admin is likely wrong: ")
            .map(void)
    }
}

