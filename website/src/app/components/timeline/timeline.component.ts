import { Component } from '@angular/core';

@Component({
  selector: 'app-timeline',
  standalone: true,
  imports: [],
  templateUrl: './timeline.component.html',
  styleUrl: './timeline.component.scss'
})
export class TimelineComponent {
  cnpqLink: String = "https://www.sciencedirect.com/science/article/abs/pii/S1007570423002940";
  unbLink: String = "https://www.unb.br/";
  finalCourseLink: String = "https://drive.google.com/file/d/1oI_TSVDzcUcDAE0RUhX-F7PRbZAwKGyR/view?usp=drive_link";
  objectiveLink: String = "https://www.objective.com.br/";
  rmLink: String = "https://radiomemory.com.br/";
  pibicLink: String = "https://drive.google.com/file/d/1x3nXGaJkBrptyTTD4qxc-FSLKuZEfjRa/view";
  unballLink: String = "https://unball.github.io/";
  matLink: String = "https://mat.unb.br/";
  maratLink: String = "http://maratona.unb.br/";
  etbLink: String = "https://moodle.etb.com.br/course/index.php";
}
