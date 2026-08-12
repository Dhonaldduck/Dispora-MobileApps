import { Repository } from 'typeorm';
import { News } from './entities/news.entity';
import { CreateNewsDto } from './dto/create-news.dto';
import { UpdateNewsDto } from './dto/update-news.dto';
export declare class NewsService {
    private readonly newsRepository;
    constructor(newsRepository: Repository<News>);
    private generateSlug;
    create(createNewsDto: CreateNewsDto, authorId: string): Promise<News>;
    findAll(isPublic: boolean): Promise<News[]>;
    findBySlug(slug: string): Promise<News>;
    findOne(id: string): Promise<News>;
    update(id: string, updateNewsDto: UpdateNewsDto): Promise<News>;
    remove(id: string): Promise<void>;
}
