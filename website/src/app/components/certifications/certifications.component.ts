import { Component } from '@angular/core';

@Component({
  selector: 'app-certifications',
  standalone: true,
  imports: [],
  templateUrl: './certifications.component.html',
  styleUrl: './certifications.component.scss'
})
export class CertificationsComponent {
  gcpACECertLink = "https://www.credly.com/badges/717e4570-53a0-4015-bb15-c1e0439b65b0/linked_in?t=t5zvn7";
  az400Link = "https://learn.microsoft.com/api/credentials/share/es-mx/HiagodosSantosRabelo-4597/9FA32C4634075A88?sharingId=57EE5433D6F9BB63";
  azureAssocCertLink = "https://learn.microsoft.com/api/credentials/share/es-mx/HiagodosSantosRabelo-4597/2EFD65939A3DADD0?sharingId=57EE5433D6F9BB63";
  azureFundCertLink = "https://learn.microsoft.com/api/credentials/share/es-mx/HiagodosSantosRabelo-4597/939A02E61F828C55?sharingId=57EE5433D6F9BB63";
  devCertLink = "https://www.credly.com/badges/8337e18e-1ba8-4d19-876f-a602fff1b5be";
  arcCertLink = "https://www.credly.com/badges/8147d80d-a2a2-4c40-bb07-a1c2d3ffa078?trk=feed_main-feed-card_feed-article-content";
  pracCertLink = "https://www.credly.com/badges/48a0c785-af6f-4aef-8b88-05222da1da43?trk=feed_main-feed-card_feed-article-content";

}
