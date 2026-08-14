import { NewsService } from './news.service';
import { CreateNewsDto } from './dto/create-news.dto';
import { UpdateNewsDto } from './dto/update-news.dto';
export declare class NewsController {
    private readonly newsService;
    constructor(newsService: NewsService);
    findAll(): Promise<import("./entities/news.entity").News[]>;
    findBySlug(slug: string): Promise<import("./entities/news.entity").News>;
    create(createNewsDto: CreateNewsDto, req: any): Promise<import("./entities/news.entity").News>;
    update(id: string, updateNewsDto: UpdateNewsDto): Promise<import("./entities/news.entity").News>;
    remove(id: string): Promise<void>;
    uploadFile(file: Express.Multer.File): {
        message: string;
        filePath: string;
    };
}
