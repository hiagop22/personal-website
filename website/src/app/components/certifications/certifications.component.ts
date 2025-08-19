import { Component } from '@angular/core';

@Component({
  selector: 'app-certifications',
  standalone: true,
  imports: [],
  templateUrl: './certifications.component.html',
  styleUrl: './certifications.component.scss'
})
export class CertificationsComponent {
  azureAssocCertLink: String = "https://learn.microsoft.com/en-us/users/hiagodossantosrabelo-4597/transcript/vpe0ncw0l25e5ge";
  azureFundCertLink: String = "https://learn.microsoft.com/en-us/users/hiagodossantosrabelo-4597/transcript/vpe0ncw0l25e5ge";
  devCertLink: String = "https://www.credly.com/badges/8337e18e-1ba8-4d19-876f-a602fff1b5be";
  arcCertLink: String = "https://www.credly.com/badges/8147d80d-a2a2-4c40-bb07-a1c2d3ffa078?trk=feed_main-feed-card_feed-article-content";
  pracCertLink: String = "https://www.credly.com/badges/48a0c785-af6f-4aef-8b88-05222da1da43?trk=feed_main-feed-card_feed-article-content";

  constructor(){}

  ngOnInit(): void{

  }
}
